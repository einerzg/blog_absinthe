defmodule BlogWeb.SchemaTest do
  use BlogWeb.ConnCase, async: false
  import Blog.AccountsFixtures

  describe "mutations: users" do
    @login_user_mutation """
      mutation AuthenticateUser(
        $username: String!,
        $password: String!
      ) {
        authenticateUser(
          username: $username,
          password: $password
        ) {
          token
          user {
            username
          }
        }
      }
    """

    test "create user successfull", %{conn: conn} do
      create_user_mutation = """
        mutation CreateUser(
          $username: String!,
          $contact: ContactInput!,
          $password: String!
        ) {
          createUser(
            username: $username,
            contact: $contact,
            password: $password
          ) {
            username
            contacts {
              type
              value
            }
          }
        }
      """

      user_attrs = %{
        username: "user1",
        password: "12345",
        contact: %{type: "EMAIL", value: "user1@mail.com"}
      }

      assert {:ok, %{"createUser" => response}} =
               run_graphql(conn, create_user_mutation, user_attrs)

      assert response["username"] == user_attrs.username
      assert hd(response["contacts"])["type"] == user_attrs.contact.type
      assert hd(response["contacts"])["value"] == user_attrs.contact.value
    end

    test "login user successfull", %{conn: conn} do
      user = user_fixture()

      credential_attrs = %{
        username: user.username,
        password: "some password"
      }

      assert {:ok, %{"authenticateUser" => response}} =
               run_graphql(conn, @login_user_mutation, credential_attrs)

      assert is_binary(response["token"])
      assert response["user"]["username"] == user.username
    end

    test "login user invalid credentials", %{conn: conn} do
      user = user_fixture()

      credential_attrs = %{
        username: user.username,
        password: "invalid password"
      }

      assert {:error, [%{"message" => "Wrong credentials", "path" => ["authenticateUser"]}],
              %{"authenticateUser" => nil}} =
               run_graphql(conn, @login_user_mutation, credential_attrs)
    end
  end

  describe "mutations: posts" do
    test "create a post successfull", %{conn: conn} do
      create_post_mutation = """
      mutation CreatePost(
        $title: String!,
        $body: String!,
        $publishedAt: NaiveDateTime
      ) {
        createPost(
        title: $title,
        body: $body,
        publishedAt: $publishedAt
        ) {
          id
          title
          body
          author {
            id
            username
          }
        }
      }
      """

      post_attrs = %{
        title: "Post1",
        body: "Body example for a large post",
        publishedAt: "2024-05-29T00:00:00Z"
      }

      user = user_fixture()

      assert {:ok, %{"createPost" => response}} =
               conn
               |> authenticated(user.id)
               |> run_graphql(create_post_mutation, post_attrs)

      assert response["body"] == post_attrs.body
      assert response["title"] == post_attrs.title
      assert response["author"]["id"] == user.id
      assert response["author"]["username"] == user.username
    end
  end

  describe "queries: posts" do
    import Blog.ContentFixtures

    test "get all posts ", %{conn: conn} do
      get_posts_query = """
        query GetPosts {
          posts {
            id
            title
            publishedAt
            author {
              id
              username
            }
          }
        }
      """

      post = post_fixture()

      assert {:ok, %{"posts" => response}} =
               conn
               |> authenticated(post.author_id)
               |> run_graphql(get_posts_query, %{})

      assert hd(response)["id"] == post.id
      assert hd(response)["title"] == post.title
      assert hd(response)["author"]["id"] == post.author_id
    end

    test "get user's posts", %{conn: conn} do
      get_my_posts = """
        query GetMyPosts {
          getMyPosts {
            id
            title
            body
            publishedAt
            author {
              id
            }
          }
        }
      """

      post = post_fixture()

      assert {:ok, %{"getMyPosts" => response}} =
               conn
               |> authenticated(post.author_id)
               |> run_graphql(get_my_posts, %{})

      assert hd(response)["id"] == post.id
      assert hd(response)["title"] == post.title
      assert hd(response)["author"]["id"] == post.author_id
    end
  end

  describe "queries: user" do
    @get_current_user """
      query GetUser {
        user {
          id
          username
          contacts {
            value
          }
        }
      }
    """

    test "get current user", %{conn: conn} do
      user = user_fixture()

      assert {:ok, %{"user" => response}} =
               conn
               |> authenticated(user.id)
               |> run_graphql(@get_current_user, %{})

      assert response["id"] == user.id
      assert response["username"] == user.username
      assert hd(response["contacts"])["value"] == hd(user.contacts).value
    end

    test "get current user without auth", %{conn: conn} do
      assert {:error, errors, _} = run_graphql(conn, @get_current_user, %{})
      assert [%{"message" => "Wrong credentials", "path" => ["user"]}] == errors
    end
  end
end

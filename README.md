# Blog Absinthe

This repository contains example code for a blog project using Phoenix and Absinthe. It is designed to be a beginner-friendly guide on how to build GraphQL APIs with Absinthe in the Phoenix framework.

## Objective

The objective of this project is to provide a practical and up-to-date example of how to create a blog using Phoenix and Absinthe, covering queries, mutations, context, tests, and basic schema definitions.

## Target Versions

- **Phoenix** v1.7.11
- **Absinthe** v1.7

## Installation

Follow these steps to set up and run the project locally.

### Prerequisites

- Elixir 1.14 or higher
- Phoenix 1.7.11

### Steps

1. Clone this repository:

   ```
   git clone https://github.com/einerzg/blog_absinthe.git
   cd blog_absinthe
   ```

2. Install Elixir and Phoenix dependencies:

   ```
   mix deps.get
   ```

3. Set up the database:

   ```
   mix ecto.setup
   ```

4. Start the Phoenix server:

   ```
   mix phx.server
   ```

5. Open your web browser and go to `http://localhost:4000` to see the application in action.

## Features

- **Queries**: Get posts, users, and their relationships.
- **Mutations**: Create, and get posts and users.
- **Basic Authentication**: Provide simple authentication to protect certain operations.

## Project Structure

- `lib/blog_absinthe_web/schema.ex`: Defines the GraphQL schema.
- `lib/blog_absinthe_web/resolvers`: Contains resolvers to handle GraphQL operations.
- `lib/blog_absinthe/accounts`: Modules related to user management.
- `lib/blog_absinthe/blog`: Modules related to post management.

## Additional Resources

- [Phoenix Documentation](https://hexdocs.pm/phoenix/overview.html)
- [Absinthe Documentation](https://hexdocs.pm/absinthe/overview.html)

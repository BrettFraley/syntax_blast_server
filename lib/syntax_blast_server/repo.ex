defmodule SyntaxBlastServer.Repo do
  use Ecto.Repo,
    otp_app: :syntax_blast_server,
    adapter: Ecto.Adapters.SQLite3
end

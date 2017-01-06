defmodule BetterReddit.HTML do
  # XXX: Will break with quoted attributes containing HTML (is that legal?)
  def minify(html) do
    Regex.replace(~r/>\s+</, html, "><")
  end
end
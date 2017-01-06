defmodule BetterReddit.ListingView do
  use BetterReddit.Web, :view
  use Timex
  alias BetterReddit.Endpoint
  alias BetterReddit.Router
  alias BetterReddit.Post

  @sidebar_subreddits ~w(
    Programming
    AskReddit
    Funny
    Gifs
    Videos
    Technology
    ShowerThoughts
    ExplainLikeImFive
    Overwatch
    TodayILearned
    AskScience
    UpliftingNews
    Pics
  )

  def listing_path(listing) do
    Router.Helpers.listing_path(Endpoint, :show, listing)
  end

  def listing_class(listing, current_listing) do
    if listing == current_listing do
      "site-sidebar-item is-current"
    else
      "site-sidebar-item"
    end
  end

  def render_post(post) do
    render("post.html", post: post)
  end

  def thumbnail_url(post) do
    "/thumbnails/#{post.thumbnail}"
  end

  def nsfw_class(post) do
    if post.is_nsfw do
      "is-nsfw"
    else
      ""
    end
  end

  def get_post_path(post) do
    post_path(Endpoint, :show, Post.get_id(post))
  end

  def sidebar_subreddits do
    @sidebar_subreddits |> Enum.sort 
  end

  def domain(url) do
    uri = URI.parse(url)
    uri.host
  end

  def how_long_ago(since) do
    now = Timex.now
    minutes = Timex.diff(now, since, :minutes)
    hours = Timex.diff(now, since, :hours)
    days = Timex.diff(now, since, :days)

    cond do
      days > 0 -> pluralize("day", days)
      hours > 0 -> pluralize("hour", hours)
      minutes > 0 -> pluralize("minute", minutes)
      :else -> "no time"
    end
  end

  defp pluralize(word, number) when number == 1, do: "#{number} #{word}"
  defp pluralize(word, number), do: "#{number} #{word}s"
end

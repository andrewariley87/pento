defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Make a guess:",
        current_time: time(),
        range: range(),
        answer: get_answer()
      )
    }
  end

  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>

    <h2>
      <p>
        <%= @message %>
      </p>
      <p>
        It's <%= @current_time %>
      </p>
      <p hidden>
        Answer is: <%= @answer %>
      </p>
    </h2>
    <br />
    <h2>
      <%= for n <- @range do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
          text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
    </h2>
    """
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    current_time = time()
    result = handle_guess(guess == socket.assigns.answer, guess, socket)

    {
      :noreply,
      assign(
        socket,
        message: result[:message],
        score: result[:score],
        answer: result[:answer],
        current_time: current_time
      )
    }
  end

  def time() do
    DateTime.utc_now() |> to_string
  end

  def range() do
    1..11
  end

  def get_answer() do
    range()
    |> Enum.random()
    |> to_string
  end

  def handle_guess(true, guess, socket) do
    %{
      score: socket.assigns.score + 1,
      message: "Your guess: #{guess}. Was correct! Guess Again? ",
      answer: get_answer()
    }
  end

  def handle_guess(false, guess, socket) do
    %{
      score: socket.assigns.score - 1,
      message: "Your guess: #{guess}. Wrong. Guess again. ",
      answer: socket.assigns.answer
    }
  end
end

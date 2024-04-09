def keyboard_markup
  Telegram::Bot::Types::ReplyKeyboardMarkup.new(
    keyboard: [
      [{ text: 'Meditation' }, { text: 'Lebowski Quote' }],
      [{ text: 'The Dude Testament' }, { text: 'Read the Tao' }],
      [{ text: 'White Russian Recipe' }, { text: 'Buy books' }, { text: 'Help' }],
    ], one_time_keyboard: true)
end

def run_meditation_timer(bot, message, time)
  # Convert the response to an integer and calculate the time in seconds
  meditation_time = time * 60

  # Send a message that it's starting
  bot.api.send_message(chat_id: message.from.id, text: "Timer start now 🧘")

  # Send an image
  photo_path = "media/meditation.jpg"
  bot.api.send_photo(chat_id: message.from.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))

  # Send an mp3 file
  audio_path = "media/meditation.mp3"
  bot.api.send_audio(chat_id: message.from.id, audio: Faraday::UploadIO.new(audio_path, 'audio/mpeg'))
  # bot.api.send_message(chat_id: message.chat.id, text: 'https://www.youtube.com/watch?v=0Ni00XDSd6E')

  # Start the timer
  sleep meditation_time

  # Send a message when the timer is done
  bot.api.send_message(chat_id: message.from.id, text: "Far out! Your meditation is complete. 🚶")
end

def tao_verses
  verses = []
  (1..81).each_slice(8) do |slice|
    row = slice.map do |num|
      Telegram::Bot::Types::InlineKeyboardButton.new(text: num.to_s, callback_data: "#{num}")
    end
    verses << row
  end
  verses
end

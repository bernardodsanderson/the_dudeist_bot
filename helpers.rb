def keyboard_markup
  Telegram::Bot::Types::ReplyKeyboardMarkup.new(
    keyboard: [
      [{ text: 'Meditation' }, { text: 'Lebowski Quote' }],
      [{ text: 'Caucasian Recipe' }, { text: 'Read the Tao' }],
      [{ text: 'The Dude Testament' }, { text: 'Help' }],
    ], one_time_keyboard: true)
end

def keyboard_inline_markup
  Telegram::Bot::Types::InlineKeyboardMarkup.new(
    inline_keyboard: [
      [[
        Telegram::Bot::Types::InlineKeyboardButton.new(text: 'meditation', callback_data: 'meditation'),
      ]]
    ]
  )
end

def run_meditation_timer(bot, time)
  # Convert the response to an integer and calculate the time in seconds
  meditation_time = time * 60

  # Send a message that it's starting
  bot.api.send_message(chat_id: message.chat.id, text: "Timer start now 🧘")

  # Send an image
  photo_path = "./meditation.jpg"
  bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))

  # Send an mp3 file
  audio_path = "./meditation.mp3"
  bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new(audio_path, 'audio/mpeg'))

  # Start the timer
  sleep meditation_time

  # Send a message when the timer is done
  bot.api.send_message(chat_id: message.chat.id, text: "Far out! Your meditation is complete. 🚶")
end
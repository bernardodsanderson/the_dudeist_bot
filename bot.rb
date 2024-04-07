#!/user/bin/env ruby
require 'telegram/bot'
require 'faraday'
require 'httparty'
require './helpers.rb'
require 'dotenv/load'

token = ENV['TOKEN']

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::InlineQuery
      # nothing for now
    when Telegram::Bot::Types::Message
      case message.text
        # START
        when '/start', 'start', 'Start'
          bot.api.send_message(chat_id: message.chat.id, text: "Right on, #{message.from.first_name}", reply_markup: keyboard_markup)
        # MEDITATION
        when '/meditation', 'meditation', 'Meditation'
    
          # Ask how long they want to meditate
          bot.api.send_message(chat_id: message.chat.id, text: "How long would you like to meditate? (in minutes)")
    
          # Listen for the user's response
          bot.listen do |response|
            # Check if the response is a valid number
            if response.text.to_i.to_s == response.text
              # Convert the response to an integer and calculate the time in seconds
              meditation_time = response.text.to_i. * 60
    
              # Send a message that it's starting
              bot.api.send_message(chat_id: message.chat.id, text: "Timer start now 🧘")
    
              # Send an image
              photo_path = "./meditation.jpg"
              bot.api.send_photo(chat_id: message.chat.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))
    
              # Send an mp3 file
              audio_path = "./meditation.mp3"
              bot.api.send_audio(chat_id: message.chat.id, audio: Faraday::UploadIO.new(audio_path, 'audio/mpeg'))
              # bot.api.send_message(chat_id: message.chat.id, text: 'https://www.youtube.com/watch?v=0Ni00XDSd6E')
    
              # Start the timer
              sleep meditation_time
    
              # Send a message when the timer is done
              bot.api.send_message(chat_id: message.chat.id, text: "Far out! Your meditation is complete. 🚶")
            else
              # If the response is not a valid number, ask again
              bot.api.send_message(chat_id: message.chat.id, text: "Please enter a valid number")
            end
          end
        # LEBOWSKI QUOTES
        when '/lebowski', 'lebowski quote', 'Lebowski Quote'
          # Give a random quote for now
          url = 'https://www.thebiglebow.ski/api/v1/random/favorite'
          response = HTTParty.get(url)
    
          bot.api.send_photo(chat_id: message.chat.id, photo: response.parsed_response['still_with_text'])
          bot.api.send_message(chat_id: message.chat.id, text: response.parsed_response['quote'], reply_markup: keyboard_markup)
        # CAUCASIAN RECIPE
        when '/recipe', 'Caucasian recipe', 'Caucasian Recipe'
          # Send back the recipe text and an image
          bot.api.send_message(chat_id: message.chat.id, text: "Another Caucasian, Gary")
        # TAO TE CHING
        when '/tao', 'tao', 'Read the Tao'
          # Ask if they want a random verse or pick a specific one
          bot.api.send_message(chat_id: message.chat.id, text: "Tao is the way, #{message.from.first_name}")
        # THE DUDE TESTAMENT
        when '/testament', 'the dude testament', 'The Dude Testament'
          bot.api.send_message(chat_id: message.chat.id, text: "Were you listening to The Dude's Testament?")
        # STOP
        when '/stop', 'stop', 'Stop'
          kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: "Did I urinate on your rug, #{message.from.first_name}?", reply_markup: kb)
        # HELP
        when '/help', 'help', 'Help'
          # Send a list of commands
          bot.api.send_message(chat_id: message.chat.id, text: "Is this a-what day is it?")
        end
    end
  end
end

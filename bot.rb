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
    when Telegram::Bot::Types::CallbackQuery
      # Handle callbacks
      case message.data.to_i
      when 1..81
        verse = "tao/#{message.data}.md"
        text = File.read(verse)
        bot.api.send_message(chat_id: message.from.id, text: text, parse_mode: 'Markdown', reply_markup: keyboard_markup)
      end
    when Telegram::Bot::Types::Message
      case message.text
        # START
        when '/start', 'start', 'Start'
          bot.api.send_message(chat_id: message.chat.id, text: "Right on, #{message.from.first_name}", reply_markup: keyboard_markup)
        # MEDITATION
        when '/meditation', 'meditation', 'Meditation'

          # Ask how long they want to meditate
          bot.api.send_message(chat_id: message.chat.id, text: "https://www.youtube.com/watch?v=vHheEy-0a7o", reply_markup: keyboard_markup)
        # LEBOWSKI QUOTES
        when '/lebowski', 'lebowski quote', 'Lebowski Quote'
          # Give a random quote for now
          url = 'https://www.thebiglebow.ski/api/v1/random/favorite'
          response = HTTParty.get(url)

          bot.api.send_photo(chat_id: message.chat.id, photo: response.parsed_response['still_with_text'])
          bot.api.send_message(chat_id: message.chat.id, text: response.parsed_response['quote'], reply_markup: keyboard_markup)
        # CAUCASIAN RECIPE
        when '/recipe', 'Caucasian recipe', 'Caucasian Recipe', 'White Russian recipe', 'White Russian Recipe'
          # Send back the recipe text and an image
          photo_path = "./lebowski_drink.jpeg"
          bot.api.send_photo(chat_id: message.from.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))
          bot.api.send_message(chat_id: message.chat.id, text: "
            1 1/2 ounces chilled vodka\n2/3 ounce Kahlua, or other coffee liqueur\n2/3 ounce light cream")
          bot.api.send_message(chat_id: message.chat.id, text:
            "Fill a rocks glass with ice\nPour in two shots of vodka and three shots of Kahlúa\nTop off with milk\nStir and serve", reply_markup: keyboard_markup)
        # TAO TE CHING
        when '/tao', 'tao', 'Read the Tao'
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: tao_verses)
          # Ask if they want a random verse or pick a specific one
          bot.api.send_message(chat_id: message.chat.id, text: "Pick a verse, #{message.from.first_name}", reply_markup: markup)
        # THE DUDE TESTAMENT
        when '/testament', 'the dude testament', 'The Dude Testament'
          doc_path = "./dude_testament.pdf"
          bot.api.send_document(chat_id: message.from.id, document: Faraday::UploadIO.new(doc_path, 'application/pdf'))
          bot.api.send_message(chat_id: message.chat.id, text: "Were you listening to The Dude's Testament?")
        # STOP
        when '/stop', 'stop', 'Stop'
          kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: "Did I urinate on your rug, #{message.from.first_name}?", reply_markup: kb)
        # HELP
        when '/help', 'help', 'Help'
          # Send a list of commands
          bot.api.send_message(chat_id: message.chat.id, text: "Is this a-what day is it?", reply_markup: keyboard_markup)
        end
    end
  end
end

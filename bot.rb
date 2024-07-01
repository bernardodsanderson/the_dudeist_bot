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
        photo_path = "media/dude.jpeg"
        bot.api.send_message(chat_id: message.from.id, text: text, parse_mode: 'Markdown', reply_markup: keyboard_markup)
        bot.api.send_photo(chat_id: message.from.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))
      end

      case message.data
      when 'audio'
        bot.api.send_message(chat_id: message.from.id, text: "https://www.youtube.com/watch?v=ai14uvPXHN8", reply_markup: keyboard_markup)
      when 'pdf'
        doc_path = "media/dude_testament.pdf"
        bot.api.send_document(chat_id: message.from.id, document: Faraday::UploadIO.new(doc_path, 'application/pdf'))
      when 'dude de ching'
        doc_path = "tao/dude_de_ching.md"
        bot.api.send_document(chat_id: message.from.id, document: Faraday::UploadIO.new(doc_path, 'text/markdown'))
      end
    when Telegram::Bot::Types::Message
      case message.text
        # START
        when '/start', 'start', 'Start'
          bot.api.send_message(chat_id: message.chat.id, text: "Right on, #{message.from.first_name}", reply_markup: keyboard_markup)
        # MEDITATION
        when '/meditation', 'meditation', 'Meditation', '🧘 Meditation'
          # Ask how long they want to meditate
          bot.api.send_message(chat_id: message.chat.id, text: "https://www.youtube.com/watch?v=vHheEy-0a7o", reply_markup: keyboard_markup)
        # LEBOWSKI QUOTES
        when '/lebowski', 'lebowski quote', 'Lebowski Quote', '💬 Lebowski Quote'
          # Give a random quote for now
          url = 'https://www.thebiglebow.ski/api/v1/random/favorite'
          response = HTTParty.get(url)

          bot.api.send_photo(chat_id: message.chat.id, photo: response.parsed_response['still_with_text'])
          bot.api.send_message(chat_id: message.chat.id, text: response.parsed_response['quote'], reply_markup: keyboard_markup)
        # CAUCASIAN RECIPE
        when '/recipe', 'Caucasian recipe', 'Caucasian Recipe', 'White Russian recipe', 'White Russian Recipe', '🍸 White Russian Recipe'
          # Send back the recipe text and an image
          photo_path = "media/lebowski_drink.jpeg"
          bot.api.send_photo(chat_id: message.from.id, photo: Faraday::UploadIO.new(photo_path, 'image/jpeg'))
          bot.api.send_message(chat_id: message.chat.id, text: "
            1 1/2 ounces chilled vodka\n2/3 ounce Kahlua, or other coffee liqueur\n2/3 ounce light cream")
          bot.api.send_message(chat_id: message.chat.id, text:
            "Fill a rocks glass with ice\nPour in two shots of vodka and three shots of Kahlúa\nTop off with milk\nStir and serve", reply_markup: keyboard_markup)
        # TAO TE CHING
        when '/tao', 'tao', 'Read the Tao', '📕 Read the Tao'
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: tao_verses)
          # Ask if they want a random verse or pick a specific one
          bot.api.send_message(chat_id: message.chat.id, text: "Pick a verse, #{message.from.first_name}", reply_markup: markup)
        # THE DUDE TESTAMENT
        when '/testament', 'the dude testament', 'The Dude Testament', '✍️ The Dude Testament'
          kb = [[
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'PDF', callback_data: 'pdf'),
            Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Audio', callback_data: 'audio')
          ]]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          bot.api.send_message(chat_id: message.chat.id, text: "Were you listening to The Dude's Testament?", reply_markup: markup)
        # STOP
        when '/stop', 'stop', 'Stop'
          kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: "Did I urinate on your rug, #{message.from.first_name}?", reply_markup: kb)
        when 'books', 'Books', 'buy books', 'Buy books', '📚 Buy books'
          kb = [
            [
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'The Incomplete Dudeist Priest\'s Handbook', url: 'https://amzn.to/4azqII4')
            ],[
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'The Dude De Ching', url: 'https://amzn.to/3JeUQfM')
            ],[
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'The Tao of the Dude', url: 'https://amzn.to/3JcgUYd')
            ],[
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'The Abide Guide', url: 'https://amzn.to/3xrCGVs')
            ],[
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Lebowski 101', url: 'https://amzn.to/3Jch2a9')
            ],[
              Telegram::Bot::Types::InlineKeyboardButton.new(text: 'Dudeism and Ministry Sciences', url: 'https://amzn.to/3U78mIp')
            ]
          ]
          markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
          bot.api.send_message(chat_id: message.chat.id, text: "That's fucking interesting, man. That's fucking interesting.", reply_markup: markup)
        # HELP
        when '/help', 'help', 'Help', 'ℹ️ Help'
          # Send a list of commands
          bot.api.send_message(chat_id: message.chat.id, text: "Is this a-what day is it?\nThis bot is for helping Dudes follow the Dudeist path. Get ordained and find more information at: https://dudeism.com/", reply_markup: keyboard_markup)
        end
    end
  end
end

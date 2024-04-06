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

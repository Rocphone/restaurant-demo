require 'twilio-ruby'
require 'sanitize'


class TwilioController < ApplicationController

JORDAN = '+14156016003'
JEFF = '+14152691903'
SEAN = '+13057266671'




  def index
    render text: "Dial Me."
  end


    def ivr_welcome
      welcome = 'The you for Calling Cheebo.'
      message = 'For Reservatoins, please press 1. For our Restaurant hours, 2. For a operator press 3.'
      response = Twilio::TwiML::VoiceResponse.new do |r|
        r.gather numDigits: '1', action: menu_path do |g|
          g.say welcome, voice: 'female', language: 'en-GB'
          g.pause(length: 1)
          g.say message, voice: 'female', language: 'en-GB'
          g.pause(length: 8)
          g.say message, voice: 'female', language: 'en-GB'
        end
        r.say "I'm sorry. I haven't received a response. Please try again later.", voice: 'alice', language: 'en-GB'
        r.hangup
      end

      render xml: response.to_s
    end









  # GET ivr/selection
  def menu_selection
    user_selection = params['Digits']

    case user_selection
    when '1' then twiml_connect('One moment please.', JORDAN)
    when '2' then twiml_connect('One moment please.', JEFF)
    when '3' then twiml_connect('One moment please.', SEAN)
    when '4' then twiml_connect('One moment please.', JORDAN)
    when '5' then twiml_connect('One moment please.', JEFF)
    when '6' then twiml_connect('One moment please.', SEAN)
    when '9' then twiml_connect('One moment while we connect you.', SEAN)
      else else_statement
    end
  end


  # POST/GET ivr/planets
  # planets_path
  def planet_selection
    user_selection = params[:Digits]

    case user_selection
    when "2"
      twiml_dial("+12024173378")
    when "3"
      twiml_dial("+12027336386")
    when "4"
      twiml_dial("+12027336637")
    else
      @output = "Returning to the main menu."
      twiml_say(@output)
    end
  end

  private

  def list_planets
    message = "To call the planet Broh doe As O G, press 2. To call the planet
    DuhGo bah, press 3. To call an oober asteroid to your location, press 4. To
    go back to the main menu, press the star key."

    response = Twilio::TwiML::VoiceResponse.new do |r|
      gather = Twilio::TwiML::Gather.new(num_digits: '1', action: planets_path)
      gather.say(message, voice: 'alice', language: 'en-GB', loop: 3)
      r.append(gather)
    end

    render xml: response.to_s
  end

  def twiml_say(phrase, exit = false)
    # Respond with some TwiML and say something.
    # Should we hangup or go back to the main menu?
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say(phrase, voice: 'alice', language: 'en-GB')
      if exit
        r.say("Thank you for calling the ET Phone Home Service - the
        adventurous alien's first choice in intergalactic travel.")
        r.hangup
      else
        r.redirect(welcome_path)
      end
    end

    render xml: response.to_s
  end

  def twiml_dial(phone_number)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.dial(number: phone_number)
    end

    render xml: response.to_s
  end

  def twiml_connect(output, phone_number)
    response = Twilio::TwiML::VoiceResponse.new do |r|
      r.say output, voice: 'alice', language: 'en-GB'
      r.dial number: phone_number
    end

    render xml: response.to_s
  end
end

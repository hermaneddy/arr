
require 'tk'
require 'webrick'
require 'webrick/https' # SEE THIS?



require "podio"


root = TkRoot.new
root.title = "Window"

@@entry1 = TkEntry.new(root)
@@entry2 = TkEntry.new(root) do
     show '*'
end

@variable1 = TkVariable.new
@variable2 = TkVariable.new
@@entry1.text@variable = @variable1
@@entry2.text@variable = @variable2
@variable1.value = "Enter any text value"
@variable2.value = "Password"


@@entry1.place('height' => 25,
            'width'  => 150,
            'x'      => 10,
            'y'      => 10)

@@entry2.place('height' => 25,
            'width'  => 150,
            'x'      => 10,
            'y'      => 40)

		
class Podio::NotificationGroup < ActivePodio::Base
  property :context, :hash
  property :notifications, :hash
  delegate_to_hash :context, :ref, :data, :comment_count, :link, :space, :rights

  class << self
    # @see https://developers.podio.com/doc/notifications/get-notifications-290777
    def find_all(options={})
      list Podio.connection.get { |req|
        req.url('/notification/', options)
      }.body
    end

    # @see https://developers.podio.com/doc/notifications/get-notification-v2-2973737
    def find(id)
      member Podio.connection.get("/notification/#{id}/v2").body
    end

    # @see https://developers.podio.com/doc/notifications/mark-notifications-as-viewed-by-ref-553653
    def mark_as_viewed_by_ref(ref_type, ref_id)
      Podio.connection.post("/notification/#{ref_type}/#{ref_id}/viewed").status
    end
  end
end  

			
def myproc

  Podio.setup(
  :api_key    => 'podio-widget',
  :api_secret => 'ZZI20SFaL3fErX0bgXyj1yxLa61du2LaN6uZz2TAHF8Qk6Z6jRNAkRqOM9oZ6xTB'
)

begin
  cert_name = [
  %w[CN localhost],
]

server = WEBrick::HTTPServer.new(:Port => 8000,
                                 :SSLEnable => true,
                                 :SSLCertName => cert_name)
  Podio.client.authenticate_with_credentials(@@entry1.value, @@entry2.value)
  puts "Authentication was a success, now you can start making API calls."


text = TkText.new(root) do
  width 100
  height 20
  borderwidth 1
  font TkFont.new('times 12 bold')
   pack("side" => "left",  "padx"=> "0", "pady"=> "0")
end

myhash = Hash.new

myhash = Podio::NotificationGroup.find_all( options = {} )


myhash.each do |entry|
entry["notifications"].each do |entrytext|
  text.insert 'end', "#{entrytext["text_short"]}\n\n"
end
end


rescue Podio::PodioError => ex
  puts "Something went wrong"
end
end


btn_OK = TkButton.new(root) do
  text "Login"
  borderwidth 5
  underline 0
  state "normal"
  font TkFont.new('times 10 bold')
  foreground  "black"
  activebackground "blue"
  relief      "groove"
  command (proc {myproc})

end		

btn_OK.place('height' => 25,
            'width'  => 150,
            'x'      => 10,
            'y'      => 80)
			
Tk.mainloop
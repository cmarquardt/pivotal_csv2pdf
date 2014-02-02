class Card < OpenStruct
  def type
    @table[:type]
  end
  
  def generate_pdf(pdf, cell)
    padding = 12
    
    cell.bounding_box do

      pdf.stroke_color = "666666"
      pdf.stroke_bounds

      pdf.text_box self.title, :at => [pdf.bounds.left+padding, pdf.bounds.top-padding], 
                               :width => (cell.width-padding*2), :height => 20, :size => 12,
                               :overflow => :shrink_to_fit, :min_font_size => 10, :style => :bold

      pdf.fill_color "444444"
      pdf.text_box self.body, :size => 9, :at => [pdf.bounds.left+padding, pdf.bounds.top-padding-34], 
                              :width => (cell.width-padding*2), :height => 90
      pdf.fill_color "000000"

      #generate_qrcode
      #pdf.image(qrcode_filename, :at => [cell.width-100,120], :fit => [100, 100])

      pdf.text_box "Points: " + self.points,
        :size => 10, :at => [12, 50], :width => cell.width-18
      pdf.text_box "Owner: " + self.owner,
        :size => 8, :at => [12, 18], :width => cell.width-18

      pdf.fill_color "999999"
      pdf.text_box "#{self.type.capitalize} #{self.story_id}",  :size => 8,  :align => :right, :at => [12, 18], :width => cell.width-18
      pdf.fill_color "000000"

    end
  end
  
  #def generate_qrcode
  #  RQR::QRCode.create do |qr|
  #    qr.save(self.url, qrcode_filename)
  #  end
  #end
  
  def qrcode_filename 
    File.join(File.dirname(__FILE__), "qrcode_#{self.story_id}.png")
  end
  
  def self.read_from_csv(csv_file)
    stories = CSV.read(csv_file)
    headers = stories.shift
    
    # --- Create cards objects

    # Id,Story,Labels,Iteration,Iteration Start,Iteration End,Story Type,Estimate,Current State,Created at,Accepted at,Deadline,Requested By,Description,URL,Owned By,Comment,Comment,Comment,Comment,Comment,Comment,Comment,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status,Task,Task Status

    stories.map do |story|
      attrs =  { :story_id     => story[0]   || '',
                 :title  => story[1]   || '',
                 :body   => story[13]  || '',
                 :type   => story[6]   || '',
                 :points => story[7]   || '...',
                 :owner  => story[15]  || '.'*50,
                 :url    => story[14] }

      Card.new attrs
    end
  end
  
end
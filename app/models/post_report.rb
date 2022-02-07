class PostReport < Struct.new(:word_count, :word_histogram)
  def self.generate(post)
    PostReport.new(
      post.content.split.map{ |word| word.gsub(/\W/, '') }.count,
      calc_histogram(post)
    )
  end

  private

  def self.calc_histogram(post)
    words = post.content.split
    .map{ |word| word.gsub(/\W/, '').downcase }
    histogram = Hash.new(0)
    words.each do |word|
      histogram[word] += 1
    end
    histogram
  end
end
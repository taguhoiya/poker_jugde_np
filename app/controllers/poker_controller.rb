class PokerController < ApplicationController
  def index
  end

  def create

    # emptyでないかまずバリデーション
    if params[:array].empty?
      @text = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
      render :index and return
    end

    @array = params[:array]

    @m_array = @array.scan(/[CDHS]/)
    @n_array = @array.scan(/\d{1,2}/)


    @strtoint = @n_array.map{|n| n.to_i}

    @scan_m = @m_array.count
    @scan_space = @array.scan(/ +/)

    @count_n = @n_array.uniq.count
    @count_m = @m_array.uniq.count

    @sort_n = @strtoint.sort
    @variation = @sort_n[4] - @sort_n[0]

    @count_overlap = @strtoint.group_by(&:itself).map{ |key, value| [key, value.count] }.sort{ |a, b| a[1] <=> b[1] }
    @get_value = @count_overlap.map{|row| row[1]}

    for num in 1..9
      @arrange = [num, num+1, num+2, num+3, num+4]
    end
  
    #マークが正しいか(CDHS以外のアルファベットを入れた場合)
    if @scan_m >= 1 && @scan_m <= 4
      @text = "入力されたマークが指定の4種類ではありません。半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"

    #数字が正しいか

    #余分なスペースがないかバリデーション（二文字以上のスペース＋文頭文末に１文字以上のスペース＋カードが五枚入力されているか）
    elsif @array.scan(/  +/).present?
      @text = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"

    elsif @array.scan(/^ +/).present? && @array.scan(/ +$/).present?
      @text = "先頭にも末尾にもスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    
    elsif @array.scan(/^ +/).present?
      @text = "先頭にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"

    elsif @array.scan(/ +$/).present?
      @text = "末尾にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"


    #ロイヤルストレートフラッシュ…同じマークのA・K・Q・J・10
    elsif @sort_n == [1, 10, 11, 12, 13]   && @count_m == 1 
      @text = "ロイヤルストレートフラッシュ"
  
    #ストレートフラッシュ…同じマークで連番
    elsif @count_m == 1 && @variation == 4
        @text = "ストレートフラッシュ" 
    
    #フォーカード…同じ数字が4枚
    elsif @get_value == [1, 4]
        @text = "フォーカード"

    #フルハウス…同じ数字が3枚と同じ数字が2枚の組み合わせ
    elsif @get_value == [2, 3]
        @text = "フルハウス"

    #ストレート…連番
    elsif @count_n == 5  && @variation == 4
        @text = "ストレート"

    #フラッシュ…同じマークが5枚
    elsif @count_m == 1 && @count_n == 5
        @text = "フラッシュ"
    
    #スリーカード…同じ数字が3枚
    elsif @get_value == [1, 1, 3] 
        @text = "スリーカード"

    #ツーペア
    elsif @get_value == [1, 2, 2] 
        @text = "ツーペア"

    #ワンペア
    elsif @get_value == [1, 1, 1, 2]
        @text = "ワンペア"

    #ハイカード
    else
        @text = "ハイカード"
    end

    render :index

  end
end

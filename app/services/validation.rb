class Validation
  def validate_input(params)
    @array = params[:array]
    @m_array_scanned = @array.scan(/[CDHS]/)
    @make_array = @array.split
    # 例外バリデーション || カード数が5より大きい
    if @array.empty? || @make_array.size != 5
      input_warn = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    end

    # カードが重複していないか
    if (@make_array.count - @make_array.uniq.count).positive?
      input_warn = "カードが重複しています。"
    end

    # 余分なスペースがないかバリデーション（二文字以上のスペース＋文頭文末に１文字以上のスペース＋カードが五枚入力されているか）
    if @array.scan(/  +/).present?
      input_warn = "5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    end
    if @array.scan(/^ +/).present?
      input_warn = "先頭にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    end
    if @array.scan(/ +$/).present?
      input_warn = "末尾にスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    end
    if @array.scan(/^ +/).present? && @array.scan(/ +$/).present?
      input_warn = "先頭にも末尾にもスペースを入力しないでください。5つのカード指定文字を半角スペース区切りで入力してください。（例：”S1 H3 D9 C13 S11”）"
    end
    return input_warn
  end

  def validate_suit(params)
    @array = params[:array]
    @array_del_spa = @array.strip
    @arr_modi = @array_del_spa.split
    @censor = @arr_modi.reject { |e| e =~ /[CDHS]1[0123]\z/ }.reject { |e| e =~ /[CDHS][1-9]\z/ }
    @err_index = []
    @censor.each.with_index(1) do |value, index|
      @err_index << @arr_modi.index(value) + 1
    end
    @suit_warn = @err_index.zip(@censor)
    return @suit_warn
  end
end

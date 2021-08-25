class JudgeHand
  def self.judge_hand(params)
    # common
    @array = params[:array]
    @string = @array.gsub(/[[:space:]]/, "")

    # variables for mark
    @m_array = @array.scan(/[A-Z]/)
    @m_array_scanned = @array.scan(/[CDHS]/)
    @count_m = @m_array_scanned.uniq.count

    # variables for number
    @n_array = @string.split(/[A-Z]/).drop(1)
    @strtoint = @n_array.map(&:to_i)
    @count_n = @n_array.uniq.count
    @sort_n = @strtoint.sort
    @variety = @sort_n.map { |n| n - @sort_n[0] }

    # array for each card
    @array_del_spa = @array.strip
    @arr_modi = @array_del_spa.split
    @censor = @arr_modi.reject { |e| e =~ /[CDHS]1[0123]\z/ }.reject { |e| e =~ /[CDHS][1-9]\z/ }

    @count_overlap = @strtoint.group_by(&:itself).map { |key, value| [key, value.count] }.sort_by { |a| a[1] }
    @get_value = @count_overlap.map { |row| row[1] }

    # judgement
    # ロイヤルストレートフラッシュ…同じマークのA・K・Q・J・10
    @show_hand = if @sort_n == [1, 10, 11, 12, 13] && @count_m == 1
                   "ロイヤルストレートフラッシュ"

                 # ストレートフラッシュ…同じマークで連番
                 elsif @count_m == 1 && @variety == [0, 1, 2, 3, 4]
                   "ストレートフラッシュ"

                 # フォーカード…同じ数字が4枚
                 elsif @get_value == [1, 4]
                   "フォーカード"

                 # フルハウス…同じ数字が3枚と同じ数字が2枚の組み合わせ
                 elsif @get_value == [2, 3]
                   "フルハウス"

                 # ストレート…連番
                 elsif @count_m != 1 && @variety == [0, 1, 2, 3, 4]
                   "ストレート"

                 # フラッシュ…同じマークが5枚
                 elsif @sort_n != [1, 10, 11, 12, 13] && @count_m == 1
                   "フラッシュ"

                 # スリーカード…同じ数字が3枚
                 elsif @get_value == [1, 1, 3]
                   "スリーカード"

                 # ツーペア
                 elsif @get_value == [1, 2, 2]
                   "ツーペア"

                 # ワンペア
                 elsif @get_value == [1, 1, 1, 2]
                   "ワンペア"

                 # ハイカード
                 else
                   "ハイカード"
                 end
    return @show_hand
  end
end

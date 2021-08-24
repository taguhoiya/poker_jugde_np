class JudgeHand

    def self.judge_hand_api(params)
        # common
        @array = params[:array]
        @string = @array.gsub(/[[:space:]]/, '')

        # variables for mark
        @m_array = @array.scan(/[A-Z]/)
        @m_array_scanned = @array.scan(/[CDHS]/)
        @count_m = @m_array_scanned.uniq.count

        # variables for number
        @n_array = @string.split(/[A-Z]/).drop(1)
        @strtoint = @n_array.map{|n| n.to_i}
        @count_n = @n_array.uniq.count
        @sort_n = @strtoint.sort

        # array for each card
        @array_del_spa = @array.lstrip.rstrip
        @arr_modi = @array_del_spa.split(" ")
        @censor = @arr_modi.reject {|e| e =~ /[CDHS]1[0123]\z/}.reject {|e| e =~ /[CDHS][1-9]\z/}

        if @sort_n.present?
            @variety = []
            @sort_n.map.with_index do |n, i|
                @variety << @sort_n[i+1] - @sort_n[i]
                break if i==3
            end
        end

        @count_overlap = @strtoint.group_by(&:itself).map{ |key, value| [key, value.count] }.sort{ |a, b| a[1] <=> b[1] }
        @get_value = @count_overlap.map{|row| row[1]}
        # judgement
        #ロイヤルストレートフラッシュ…同じマークのA・K・Q・J・10
        if @sort_n == [1, 10, 11, 12, 13] && @count_m == 1 
            return 0
        #ストレートフラッシュ…同じマークで連番
        elsif @count_m == 1 && @variety == [1,1,1,1]
            return 1
        #フォーカード…同じ数字が4枚
        elsif @get_value == [1, 4]
            return 2
        #フルハウス…同じ数字が3枚と同じ数字が2枚の組み合わせ
        elsif @get_value == [2, 3]
            return 3
        #ストレート…連番
        elsif @count_m != 1  && @variety == [1,1,1,1]
            return 4
        #フラッシュ…同じマークが5枚
        elsif @sort_n != [1, 10, 11, 12, 13] && @count_m == 1
            return 5
        #スリーカード…同じ数字が3枚
        elsif @get_value == [1, 1, 3] 
            return 6
        #ツーペア
        elsif @get_value == [1, 2, 2] 
            return 7
        #ワンペア
        elsif @get_value == [1, 1, 1, 2]
            return 8
        #ハイカード
        else
            return 9
        end
    end
end
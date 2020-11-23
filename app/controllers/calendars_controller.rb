class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = [] #この配列が、eachメソッドにかかって、並んでいく。

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x| # 曜日ごとのデータを、DBから呼び出す
      today_plans = [] #plan欄の並び順を決める配列
      plan = plans.map do |plan| # 曜日に合わせたplanを、今日の曜日から順に追加していく
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end

      wday_num = @todays_date.wday
      if wday_num < 7
        wday_num = wday_num -7
      end

      days = { month: (@todays_date + x).month, date: (@todays_date + x).day, plans: today_plans, wday: wdays[wday_num + x]}
      @week_days.push(days) # 今日の曜日から順に、配列の末尾から加えていく。→今日の日付が最初になるので、今日の日付から順に並んでいく
    end

  end
end

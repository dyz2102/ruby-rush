class DigrubyController < ApplicationController
  def index
    @minerals = current_mcart.minerals
  end

  def start_digging
    if current_user.pickax_amount >= 1
      current_user.pickax_amount -= 1
      current_user.save
      current_mcart.dig_minerals!


      redirect_to digruby_index_path
    else
      direct_to_pickax_shop
    end

    get_nine_new_minerals
  end

  def select_mineral
    current_mcart.select_mineral!

    redirect_to digruby_index_path
  end

  def dig_again
    if current_user.pickax_amount >= 1
      current_user.pickax_amount -= 1
      current_user.save
      current_mcart.dig_minerals!

      get_nine_new_minerals
      redirect_to digruby_index_path
    else
      direct_to_pickax_shop
    end
  end

  helper_method :current_mcart

  def current_mcart
    @current_mcart ||= find_mcart
  end




  def get_nine_new_minerals
    if current_mcart.minerals.present?
      Mineral.delete_all
    end

    16.times do
      r = rand(1..100)
      m = Mineral.new
      m.minerals_cart = current_mcart
      m.rubies_inside_mineral = r
      m.save
    end

  end



  private

  def find_mcart
    mcart = MineralsCart.find_by(id: session[:mcart_id])
    if mcart.blank?
      mcart = MineralsCart.create
    end
    session[:mcart_id] = mcart.id
    return mcart
  end





end

class ApplicationController < ActionController::Base
  
  # --------------------------------------------
  # ✅ Devise関連: ログイン・登録後の遷移先設定
  # --------------------------------------------
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  # --------------------------------------------
  # ✅ Deviseパラメータ許可設定
  # deviseコントローラのみ呼び出される
  # --------------------------------------------
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # --------------------------------------------
  # ✅ サインアップ・アカウント更新時にnameを許可
  # --------------------------------------------
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

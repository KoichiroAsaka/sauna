class ApplicationController < ActionController::Base
  # Deviseログイン後の遷移先
  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  # Devise新規登録後の遷移先
  def after_sign_up_path_for(resource)
    user_path(resource)
  end

  # ✅ Deviseコントローラのときだけパラメータ許可設定を呼ぶ
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # ✅ nameを許可（sign_up, account_update）
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end

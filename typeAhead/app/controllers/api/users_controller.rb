class Api::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    users = User.all
    render json: users, code: 200
  end

  def show
    render json: @user, code: 200
  end

  def create
    user = User.new(new_user_params)
    if user.save
      render json: user, code: 200
    else
      render json: { result: false, message: 'User could not be created' }, code: 422
    end
  end

  def update
    if @user.update(edit_user_params)
      render json: @user, code: 200
    else
      render json: { result: false, message: 'User could not be updated' }, code: 422
    end
  end

  def destroy
    if @user.destroy
      render json: [], code: 200
    else
      render json: { result: false, message: 'User could not be deleted' }, code: 422
    end
  end

  def typeahead
    search_on = params[:input]
    if search_on.blank?
      render json: { result: false, message: 'input string is missing' }, code: 422
    else
      users = User.or({ first_name: /.*#{search_on}.*/i }, { last_name: /.*#{search_on}.*/i }, { email: /.*#{search_on}.*/i })
      render json: users.present? ? users : [], code: 200
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
    render json: { result: false, message: 'User not found' }, code: 422 if @user.nil?
  end

  def new_user_params
    params.permit(:first_name, :last_name, :email)
  end

  def edit_user_params
    params.permit(:first_name, :last_name, :email)
  end
end

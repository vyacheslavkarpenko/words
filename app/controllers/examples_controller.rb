class ExamplesController < ApplicationController
  before_action :set_translation, only: %i[ show edit update destroy ]
  def user_examples
  end
end

require 'rails_helper'

RSpec.describe "comments/new", type: :view do
  before(:each) do
    assign(:comment, FactoryGirl.build(:comment))
  end

  it "renders new comment form" do
    render

    assert_select "form[action=?][method=?]", comments_path, "post" do

      assert_select "input#comment_author_id[name=?]", "comment[author_id]"

      assert_select "textarea#comment_body[name=?]", "comment[body]"
    end
  end
end

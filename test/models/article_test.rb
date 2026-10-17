
require "test_helper"

class ArticleTest < ActiveSupport::TestCase

  test "正常な記事は有効である" do
    article = Article.new(
      title: "JavaScript入門",
      category: "JavaScript",
      body: "JavaScriptを学習します。",
      user: users(:alice)
    )

    assert article.valid?
  end

  test "タイトルが空なら無効である" do
    article = articles(:alice_article)
    article.title = ""

    assert_not article.valid?
    assert article.errors[:title].any?
  end

  test "タイトルが100文字を超えると無効である" do
    article = articles(:alice_article)
    article.title = "あ" * 101

    assert_not article.valid?
    assert article.errors[:title].any?
  end

  test "本文が空なら無効である" do
    article = articles(:alice_article)
    article.body = ""

    assert_not article.valid?
    assert article.errors[:body].any?
  end

  test "記事には所有者が必要である" do
    article = articles(:alice_article)
    article.user = nil

    assert_not article.valid?
    assert article.errors[:user].any?
  end
end

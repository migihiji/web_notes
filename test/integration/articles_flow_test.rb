
require "test_helper"

class ArticlesFlowTest < ActionDispatch::IntegrationTest

  setup do
    @alice = users(:alice)
    @bob = users(:bob)

    @alice_article = articles(:alice_article)
    @bob_article = articles(:bob_article)
  end

  # テスト内でログインする補助メソッド
  def login_as(user)
    post session_path, params: {
      email_address: user.email_address,
      password: "test-password-123"
    }

    assert_response :redirect
  end

  test "未ログインでも記事一覧を閲覧できる" do
    get articles_path

    assert_response :success
    assert_select "h1", "Web開発学習ノート"
  end

  test "未ログインでは投稿フォームに入れない" do
    get new_article_path

    assert_redirected_to new_session_path
  end

  test "ログインすれば記事を投稿できる" do
    login_as(@alice)

    assert_difference("Article.count", 1) do
      post articles_path, params: {
        article: {
          title: "新しいUnity記事",
          category: "Unity",
          body: "新しい記事の本文です。"
        }
      }
    end

    article = Article.order(:id).last

    assert_equal @alice.id, article.user_id
    assert_redirected_to article_path(article)
  end

  test "空欄の記事は保存されない" do
    login_as(@alice)

    assert_no_difference("Article.count") do
      post articles_path, params: {
        article: {
          title: "",
          category: "Unity",
          body: "本文"
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "Aliceは自分の記事を編集できる" do
    login_as(@alice)

    patch article_path(@alice_article), params: {
      article: {
        title: "Unity応用"
      }
    }

    assert_redirected_to article_path(@alice_article)

    assert_equal "Unity応用",
                 @alice_article.reload.title
  end

  test "AliceはBobの記事を編集できない" do
    login_as(@alice)

    original_title = @bob_article.title

    patch article_path(@bob_article), params: {
      article: {
        title: "不正な書き換え"
      }
    }

    assert_response :not_found

    assert_equal original_title,
                 @bob_article.reload.title
  end

  test "AliceはBobの記事を削除できない" do
    login_as(@alice)

    assert_no_difference("Article.count") do
      delete article_path(@bob_article)
    end

    assert_response :not_found
  end

  test "Aliceは自分の記事を削除できる" do
    login_as(@alice)

    assert_difference("Article.count", -1) do
      delete article_path(@alice_article)
    end

    assert_redirected_to articles_path
  end
end

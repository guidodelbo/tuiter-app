# frozen_string_literal: true

RSpec.shared_examples 'an unauthenticated user trying to access a protected page' do
  it 'redirects to the login page', :aggregate_failures do
    expect(page).to have_current_path(login_path)

    within('.alert-danger') do
      expect(page).to have_content('Please log in')
    end
  end
end

RSpec.shared_examples 'a user profile with information and microposts' do
  it 'displays the user\'s information, stats and microposts', :aggregate_failures do
    within('section.user_info') do
      expect(page).to have_content(user.name)
      expect(page).to have_css('img.gravatar')
    end

    within('section.stats') do
      expect(page).to have_link("#{user.following.count} following", href: following_user_path(user))
      expect(page).to have_link("#{user.followers.count} followers", href: followers_user_path(user))
    end

    expect(page).to have_content("Tuits (#{user.microposts.count})")

    within('.microposts') do
      expect(page).to have_css('li span.content', count: 3)
      expect(page).to have_css('li span.timestamp', count: 3)
    end
  end
end

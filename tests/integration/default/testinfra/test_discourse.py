def test_file_exists(host):
    discourse = host.file('/discourse.yml')
    assert discourse.exists
    assert discourse.contains('your')

# def test_discourse_is_installed(host):
#     discourse = host.package('discourse')
#     assert discourse.is_installed
#
#
# def test_user_and_group_exist(host):
#     user = host.user('discourse')
#     assert user.group == 'discourse'
#     assert user.home == '/var/lib/discourse'
#
#
# def test_service_is_running_and_enabled(host):
#     discourse = host.service('discourse')
#     assert discourse.is_enabled
#     assert discourse.is_running

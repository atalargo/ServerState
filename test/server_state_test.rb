require 'test_helper'

class ServerStateTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "no maintenance" do
    assert ServerState.is_maintenance? == false
  end
  test "put in maintenance" do
    ServerState.set_in_maintenance
    assert ServerState.is_maintenance? == true
  end
  test "put out maintenance" do
    ServerState.set_in_maintenance
    ServerState.set_out_maintenance
    assert ServerState.is_maintenance? == false
  end
  test "Empty auth ips" do
    s = ServerStatus.first
    assert s.ips.empty? == true
  end
  test "add_auth_ip" do
    s = ServerStatus.first
    s.add_authorized_ip('127.0.0.1')
    assert s.ips.empty? == false
  end
  test "test up maintenance for" do
    assert ServerState.is_maintenance_for?('127.0.0.1') == false
  end
  test "test up maintenance for with maintenance true" do
    s = ServerStatus.first
    s.add_authorized_ip('127.0.0.1')
    ServerState.set_in_maintenance
    assert ServerState.is_maintenance_for?('127.0.0.1') == false && ServerState.is_maintenance?
    ServerState.set_out_maintenance
  end

  test "remove ip" do
    s = ServerStatus.first
    s.add_authorized_ip('127.0.0.1')
    s.delete_authorized_ip('127.0.0.1')
    assert s.ips.empty? == true
  end

  test "test up maintenance for unauth ip" do
    assert ServerState.is_maintenance_for?('127.0.0.1') == false
  end

  test "test up maintenance for unauth with maintenance true" do
    ServerState.set_in_maintenance
    assert ServerState.is_maintenance_for?('127.0.0.1') == true && ServerState.is_maintenance?
    ServerState.set_out_maintenance
  end
end

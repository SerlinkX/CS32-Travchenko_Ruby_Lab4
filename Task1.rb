def valid_ipv4?(ip)
  # Регулярний вираз для перевірки формату IPv4-адреси
  return false unless ip =~ /^\d{1,3}(\.\d{1,3}){3}$/

  # Розбиваємо IP на чотири частини
  segments = ip.split('.')

  # Перевіряємо кожен сегмент
  segments.all? do |segment|
    # Перевірка на те, чи немає ведучих нулів, і чи число в межах 0-255
    segment.to_i.between?(0, 255) && segment == segment.to_i.to_s
  end
end

# Приклади використання
puts valid_ipv4?("192.168.1.1")      # true
puts valid_ipv4?("255.255.255.255")  # true
puts valid_ipv4?("256.100.50.0")     # false
puts valid_ipv4?("192.168.01.1")     # false
puts valid_ipv4?("192.168.1")        # false

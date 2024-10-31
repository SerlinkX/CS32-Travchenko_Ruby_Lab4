require 'minitest/autorun'
require 'benchmark'

# Основний метод для перевірки IPv4-адреси
def valid_ipv4?(ip)
  return false unless ip =~ /^\d{1,3}(\.\d{1,3}){3}$/

  segments = ip.split('.')

  segments.all? do |segment|
    segment.to_i.between?(0, 255) && segment == segment.to_i.to_s
  end
end

# Клас для тестування
class TestValidIPv4 < Minitest::Test
  # Тести для правильних IPv4-адрес
  def test_valid_addresses
    assert_equal true, valid_ipv4?("192.168.1.1")
    assert_equal true, valid_ipv4?("255.255.255.255")
    assert_equal true, valid_ipv4?("0.0.0.0")
    assert_equal true, valid_ipv4?("127.0.0.1")
  end

  # Тести для адрес з числами поза діапазоном 0-255
  def test_out_of_range_addresses
    assert_equal false, valid_ipv4?("256.100.50.0")
    assert_equal false, valid_ipv4?("192.300.1.1")
    assert_equal false, valid_ipv4?("192.168.1.256")
  end

  # Тести для адрес з ведучими нулями
  def test_leading_zeroes
    assert_equal false, valid_ipv4?("192.168.01.1")
    assert_equal false, valid_ipv4?("255.255.255.025")
    assert_equal false, valid_ipv4?("01.02.03.04")
  end

  # Тести для неповних або надмірних адрес
  def test_incomplete_or_extra_segments
    assert_equal false, valid_ipv4?("192.168.1")
    assert_equal false, valid_ipv4?("192.168.1.1.1")
    assert_equal false, valid_ipv4?("192.168")
  end

  # Тести для нечислових або некоректних символів
  def test_invalid_characters
    assert_equal false, valid_ipv4?("192.168.a.1")
    assert_equal false, valid_ipv4?("192.168.1.1a")
    assert_equal false, valid_ipv4?("192.168..1")
  end

  # Тести для крайніх випадків
  def test_extreme_cases
    assert_equal true, valid_ipv4?("1.1.1.1")
    assert_equal true, valid_ipv4?("0.255.0.255")
    assert_equal false, valid_ipv4?("0..255.0.255") # Два крапки разом
    assert_equal true, valid_ipv4?("999.999.999.999") # За межами діапазону
    assert_equal false, valid_ipv4?("") # Пустий рядок
    assert_equal false, valid_ipv4?("    ") # Порожній рядок з пробілами
  end

  # Тест продуктивності
  def test_performance
    large_data_set = Array.new(1_000_000, "192.168.1.1") # Мільйон коректних IP

    time = Benchmark.realtime do
      large_data_set.each do |ip|
        valid_ipv4?(ip)
      end
    end

    puts "Час обробки мільйона IP-адрес: #{time} секунд"
  end
end

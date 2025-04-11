import '../models/cinema.dart';

final List<Cinema> sampleCinemas = [
  Cinema(
    id: 1,
    name: 'Galaxy Nguyễn Du',
    city: 'TP.HCM',
    coordinates: '10.7769, 106.7009', // Tọa độ giả lập cho Quận 1, TP.HCM
    address: '116 Nguyễn Du, Quận 1, TP.HCM',
    phoneNumber: '028 3823 5235',
  ),
  Cinema(
    id: 2,
    name: 'CGV Crescent Mall',
    city: 'TP.HCM',
    coordinates: '10.7298, 106.7195', // Tọa độ giả lập cho Quận 7, TP.HCM
    address: '101 Tôn Dật Tiên, Quận 7, TP.HCM',
    phoneNumber: '028 5413 8888',
  ),
  Cinema(
    id: 3,
    name: 'Lotte Cinema Gò Vấp',
    city: 'TP.HCM',
    coordinates: '10.8316, 106.6667', // Tọa độ giả lập cho Gò Vấp, TP.HCM
    address: '242 Nguyễn Văn Lượng, Gò Vấp, TP.HCM',
    phoneNumber: '028 3961 8777',
  ),
  // Thêm các rạp mới
  Cinema(
    id: 4,
    name: 'CGV Vincom Mega Mall',
    city: 'Hà Nội',
    coordinates: '21.0064, 105.8285', // Tọa độ giả lập cho Royal City, Hà Nội
    address: '72A Nguyễn Trãi, Thanh Xuân, Hà Nội',
    phoneNumber: '024 3975 8888',
  ),
  Cinema(
    id: 5,
    name: 'BHD Star Cineplex',
    city: 'Hà Nội',
    coordinates: '21.0300, 105.8481', // Tọa độ giả lập cho Ba Đình, Hà Nội
    address: 'Tầng 3, TTTM Vincom, 54A Nguyễn Chí Thanh, Ba Đình, Hà Nội',
    phoneNumber: '024 3833 6666',
  ),
  Cinema(
    id: 6,
    name: 'Galaxy Đà Nẵng',
    city: 'Đà Nẵng',
    coordinates: '16.0678, 108.2208', // Tọa độ giả lập cho trung tâm Đà Nẵng
    address: 'Tầng 4, TTTM Vincom Plaza, 910A Ngô Quyền, Sơn Trà, Đà Nẵng',
    phoneNumber: '0236 365 6565',
  ),
  Cinema(
    id: 7,
    name: 'CGV Vĩnh Nghiêm',
    city: 'TP.HCM',
    coordinates: '10.7991, 106.6802', // Tọa độ giả lập cho Quận 3, TP.HCM
    address: 'Tầng 5, TTTM Vĩnh Nghiêm, 561 Sư Vạn Hạnh, Quận 3, TP.HCM',
    phoneNumber: '028 3833 9999',
  ),
  Cinema(
    id: 8,
    name: 'Lotte Cinema Cần Thơ',
    city: 'Cần Thơ',
    coordinates: '10.0312, 105.7809', // Tọa độ giả lập cho trung tâm Cần Thơ
    address: 'Tầng 5, TTTM Sense City, 1 Đại lộ Hòa Bình, Ninh Kiều, Cần Thơ',
    phoneNumber: '0292 376 8888',
  ),
];
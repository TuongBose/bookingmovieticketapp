import '../models/room.dart';

final List<Room> sampleRooms = [
  // Galaxy Nguyễn Du (TP.HCM)
  Room(id: 1, cinemaId: 1, name: 'Room 1', seatColumnMax: 10, seatRowMax: 8),  // 10 cột x 8 hàng = 80 ghế
  Room(id: 2, cinemaId: 1, name: 'Room 2', seatColumnMax: 12, seatRowMax: 6),  // 12 cột x 6 hàng = 72 ghế

  // CGV Crescent Mall (TP.HCM)
  Room(id: 3, cinemaId: 2, name: 'Room 1', seatColumnMax: 12, seatRowMax: 10), // 12 cột x 10 hàng = 120 ghế
  Room(id: 4, cinemaId: 2, name: 'Room 2', seatColumnMax: 10, seatRowMax: 8),  // 10 cột x 8 hàng = 80 ghế

  // Lotte Cinema Gò Vấp (TP.HCM)
  Room(id: 5, cinemaId: 3, name: 'Room 1', seatColumnMax: 8, seatRowMax: 8),   // 8 cột x 8 hàng = 64 ghế
  Room(id: 6, cinemaId: 3, name: 'Room 2', seatColumnMax: 10, seatRowMax: 6),  // 10 cột x 6 hàng = 60 ghế

  // CGV Vincom Mega Mall (Hà Nội)
  Room(id: 7, cinemaId: 4, name: 'Room 1', seatColumnMax: 12, seatRowMax: 12), // 12 cột x 12 hàng = 144 ghế
  Room(id: 8, cinemaId: 4, name: 'Room 2', seatColumnMax: 10, seatRowMax: 10), // 10 cột x 10 hàng = 100 ghế

  // BHD Star Cineplex (Hà Nội)
  Room(id: 9, cinemaId: 5, name: 'Room 1', seatColumnMax: 10, seatRowMax: 8),  // 10 cột x 8 hàng = 80 ghế
  Room(id: 10, cinemaId: 5, name: 'Room 2', seatColumnMax: 8, seatRowMax: 6),  // 8 cột x 6 hàng = 48 ghế

  // Galaxy Đà Nẵng (Đà Nẵng)
  Room(id: 11, cinemaId: 6, name: 'Room 1', seatColumnMax: 10, seatRowMax: 10), // 10 cột x 10 hàng = 100 ghế
  Room(id: 12, cinemaId: 6, name: 'Room 2', seatColumnMax: 8, seatRowMax: 8),   // 8 cột x 8 hàng = 64 ghế

  // CGV Vĩnh Nghiêm (TP.HCM)
  Room(id: 13, cinemaId: 7, name: 'Room 1', seatColumnMax: 12, seatRowMax: 8),  // 12 cột x 8 hàng = 96 ghế
  Room(id: 14, cinemaId: 7, name: 'Room 2', seatColumnMax: 10, seatRowMax: 6),  // 10 cột x 6 hàng = 60 ghế

  // Lotte Cinema Cần Thơ (Cần Thơ)
  Room(id: 15, cinemaId: 8, name: 'Room 1', seatColumnMax: 12, seatRowMax: 10), // 12 cột x 10 hàng = 120 ghế
  Room(id: 16, cinemaId: 8, name: 'Room 2', seatColumnMax: 8, seatRowMax: 8),   // 8 cột x 8 hàng = 64 ghế
];

import '../models/room.dart';

final List<Room> sampleRooms = [
  Room(
    id: 1,
    cinemaId: 1,
    name: 'Phòng Chiếu 1',
    seatRows: 'ABCDEF',
    seatRowMax: 10,
  ),
  Room(
    id: 2,
    cinemaId: 1,
    name: 'Phòng Chiếu 2',
    seatRows: 'ABCD',
    seatRowMax: 12,
  ),
  Room(
    id: 3,
    cinemaId: 2,
    name: 'Phòng VIP 1',
    seatRows: 'ABCDE',
    seatRowMax: 8,
  ),
];

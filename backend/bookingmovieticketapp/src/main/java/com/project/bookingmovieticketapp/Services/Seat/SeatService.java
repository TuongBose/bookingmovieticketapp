package com.project.bookingmovieticketapp.Services.Seat;

import com.project.bookingmovieticketapp.DTOs.SeatDTO;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.SeatRepository;
import com.project.bookingmovieticketapp.Responses.SeatResponse;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SeatService implements ISeatService{
    private static final Logger logger = LoggerFactory.getLogger(SeatService.class);

    private final RoomRepository roomRepository;
    private final SeatRepository seatRepository;

    @PostConstruct
    public void init(){
        generateSeatsForAllRooms();
    }

    private void generateSeatsForAllRooms(){
        List<Room> roomList = roomRepository.findAll();
        for(Room room : roomList)
        {
            generateSeatsForRoom(room);
        }
    }

    private void generateSeatsForRoom(Room room){
        int roomId = room.getId();
        int seatColumnMax = room.getSeatcolumnmax();
        int seatRowMax = room.getSeatrowmax();

        // Kiểm tra xem phòng đã có ghế chưa
        List<Seat> existingSeats = seatRepository.findByRoom(room);
        if (!existingSeats.isEmpty()) {
            logger.info("Seats already exist for room {} (ID: {})", room.getName(), room.getId());
            return; // Bỏ qua nếu ghế đã tồn tại
        }

        // Tạo ghế dựa trên số hàng và số cột
        for (int row = 0; row < seatRowMax; row++) {
            // Chuyển số hàng thành chữ cái (0 -> A, 1 -> B, ...)
            char rowChar = (char) ('A' + row);

            for (int col = 1; col <= seatColumnMax; col++) {
                // Tạo tên ghế (ví dụ: A1, A2, B1, ...)
                String seatNumber = rowChar + String.valueOf(col);

                // Kiểm tra xem ghế đã tồn tại chưa (dự phòng)
                if (seatRepository.existsByRoomIdAndSeatnumber(roomId, seatNumber)) {
                    continue; // Bỏ qua nếu ghế đã tồn tại
                }

                // Tạo ghế mới
                Seat seat = Seat.builder()
                        .room(room)
                        .seatnumber(seatNumber)
                        .build();

                // Lưu ghế vào database
                seatRepository.save(seat);
                logger.info("Created seat {} for room {} (ID: {})", seatNumber, room.getName(), room.getId());
            }
        }
    }


    @Override
    public Seat createSeat(SeatDTO seatDTO) throws Exception {
        Room existingRoom = roomRepository.findById(seatDTO.getRoomid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        Seat newSeat = Seat
                .builder()
                .room(existingRoom)
                .seatnumber(seatDTO.getSeatnumber())
                .build();
        seatRepository.save(newSeat);
        return newSeat;
    }

    @Override
    public SeatResponse getSeatById(int id) throws Exception {
        Seat existingSeat = seatRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay SeatId"));

        return SeatResponse
                .builder()
                .id(existingSeat.getId())
                .roomId(existingSeat.getRoom().getId())
                .seatnumber(existingSeat.getSeatnumber())
                .build();
    }

    @Override
    public Seat updateSeat(int id, SeatDTO seatDTO) throws Exception {
        Seat existingSeat = seatRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay SeatId"));

        Room existingRoom = roomRepository.findById(seatDTO.getRoomid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        existingSeat.setRoom(existingRoom);
        existingSeat.setSeatnumber(seatDTO.getSeatnumber());
        seatRepository.save(existingSeat);
        return existingSeat;
    }

    @Override
    public List<SeatResponse> getSeatByRoomId(int roomId) throws Exception {
        Room existingRoom = roomRepository.findById(roomId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay RoomId"));

        List<Seat> seatList = seatRepository.findByRoom(existingRoom);
        if(seatList.isEmpty())
            throw new RuntimeException("Khong co danh sach");
        else
        {
            List<SeatResponse> seatResponseList = new ArrayList<>();
            for(Seat seat:seatList)
            {
                SeatResponse newSeatResponse = SeatResponse
                        .builder()
                        .id(seat.getId())
                        .roomId(seat.getRoom().getId())
                        .seatnumber(seat.getSeatnumber())
                        .build();
                seatResponseList.add(newSeatResponse);
            }
            return seatResponseList;
        }
    }
}

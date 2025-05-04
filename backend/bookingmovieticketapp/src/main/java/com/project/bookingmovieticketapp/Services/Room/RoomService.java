package com.project.bookingmovieticketapp.Services.Room;

import com.project.bookingmovieticketapp.DTOs.RoomDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Repositories.CinemaRepository;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.SeatRepository;
import com.project.bookingmovieticketapp.Responses.RoomResponse;
import com.project.bookingmovieticketapp.Services.Cast.CastService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.EmptyStackException;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class RoomService implements IRoomService {
    private static final Logger logger = LoggerFactory.getLogger(RoomService.class);

    private final CinemaRepository cinemaRepository;
    private final RoomRepository roomRepository;

    @PostConstruct
    public void init() {
        generateRoomsForAllCinemas();
    }

    private void generateRoomsForAllCinemas() {
        List<Cinema> cinemaList = cinemaRepository.findAll();
        for (Cinema cinema : cinemaList) {
            generateRoomsForCinema(cinema);
        }
    }

    private void generateRoomsForCinema(Cinema cinema) {
        int maxRooms = cinema.getMaxroom();

        // Kiểm tra xem rạp đã có phòng chưa
        List<Room> existingRooms = roomRepository.findByCinema(cinema);
        if (existingRooms.size() >= maxRooms) {
            logger.info("Rooms already exist for cinema {} (ID: {})", cinema.getName(), cinema.getId());
            return; // Bỏ qua nếu đã đủ số phòng
        }

        // Xóa các phòng cũ nếu cần (tùy chọn)
        // roomRepository.deleteAll(existingRooms);

        // Tạo phòng mới
        Random random = new Random();
        for (int i = 1; i <= maxRooms; i++) {
            // Kiểm tra xem phòng đã tồn tại chưa
            String roomName = "RAP " + i;
            if (existingRooms.stream().anyMatch(room -> room.getName().equals(roomName))) {
                continue; // Bỏ qua nếu phòng đã tồn tại
            }

            // Tạo kích thước phòng ngẫu nhiên
            int seatColumnMax = random.nextInt(13) + 8;  // 8-20 cột
            int seatRowMax = random.nextInt(14) + 6;     // 6-16 hàng

            Room room = Room.builder()
                    .cinema(cinema)
                    .name(roomName)
                    .seatcolumnmax(seatColumnMax)
                    .seatrowmax(seatRowMax)
                    .build();

            roomRepository.save(room);
            logger.info("Created room {} for cinema {} (ID: {})", roomName, cinema.getName(), cinema.getId());
        }
    }

    @Override
    public Room createRoom(RoomDTO roomDTO) {
        Cinema existingCinema = cinemaRepository.findById(roomDTO.getCinemaid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay CinemaId"));

        Room newRoom = Room
                .builder()
                .cinema(existingCinema)
                .name(roomDTO.getName())
                .seatcolumnmax(roomDTO.getSeatcolumnmax())
                .seatrowmax(roomDTO.getSeatrowmax())
                .build();
        roomRepository.save(newRoom);
        return newRoom;
    }

    @Override
    public RoomResponse getRoomById(int id) throws Exception {
        Room existingRoom = roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay RoomId"));

        return RoomResponse
                .builder()
                .id(existingRoom.getId())
                .cinemaId(existingRoom.getCinema().getId())
                .name(existingRoom.getName())
                .seatcolumnmax(existingRoom.getSeatcolumnmax())
                .seatrowmax(existingRoom.getSeatrowmax())
                .build();
    }

    @Override
    public Room updateRoom(int id, RoomDTO roomDTO) throws Exception {
        Room existingRoom = roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay RoomId"));

        Cinema existingCinema = cinemaRepository.findById(roomDTO.getCinemaid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay CinemaId"));

        existingRoom.setCinema(existingCinema);
        existingRoom.setName(roomDTO.getName());
        existingRoom.setSeatrowmax(roomDTO.getSeatrowmax());
        existingRoom.setSeatcolumnmax(roomDTO.getSeatcolumnmax());

        roomRepository.save(existingRoom);
        return existingRoom;
    }

    @Override
    public List<RoomResponse> getRoomByCinemaId(int cinemaId) throws Exception {
        Cinema existingCinema = cinemaRepository.findById(cinemaId)
                .orElseThrow(() -> new RuntimeException("Khong tim thay CinemaId"));
        List<Room> roomList = roomRepository.findByCinema(existingCinema);

        List<RoomResponse> roomResponseList = new ArrayList<>();
        for (Room room : roomList) {
            RoomResponse newRoomResponse = RoomResponse
                    .builder()
                    .id(room.getId())
                    .cinemaId(room.getCinema().getId())
                    .name(room.getName())
                    .seatcolumnmax(room.getSeatcolumnmax())
                    .seatrowmax(room.getSeatrowmax())
                    .build();
            roomResponseList.add(newRoomResponse);
        }

        return roomResponseList;
    }
}

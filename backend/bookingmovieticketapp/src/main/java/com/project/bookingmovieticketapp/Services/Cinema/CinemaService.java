package com.project.bookingmovieticketapp.Services.Cinema;

import com.project.bookingmovieticketapp.DTOs.CinemaDTO;
import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Repositories.CinemaRepository;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.ShowTimeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class CinemaService implements ICinemaService{
    private final CinemaRepository cinemaRepository;
    private final ShowTimeRepository showTimeRepository;
    private final RoomRepository roomRepository;

    @Override
    public Cinema createCinema(CinemaDTO cinemaDTO) {
        Cinema newCinema = Cinema
                .builder()
                .name(cinemaDTO.getName())
                .city(cinemaDTO.getCity())
                .coordinates(cinemaDTO.getCoordinates())
                .address(cinemaDTO.getAddress())
                .phonenumber(cinemaDTO.getPhonenumber())
                .build();
        cinemaRepository.save(newCinema);
        return newCinema;
    }

    @Override
    public Cinema updateCinema(int id, CinemaDTO cinemaDTO) throws Exception{
        Cinema existingCinema = cinemaRepository.findById(id)
                .orElseThrow(()->new RuntimeException("Khong tim thay CinemaId"));

        existingCinema.setName(cinemaDTO.getName());
        existingCinema.setCity(cinemaDTO.getCity());
        existingCinema.setCoordinates(cinemaDTO.getCoordinates());
        existingCinema.setAddress(cinemaDTO.getAddress());
        existingCinema.setPhonenumber(cinemaDTO.getPhonenumber());
        cinemaRepository.save(existingCinema);
        return existingCinema;
    }

    @Override
    public List<Cinema> getAllCinema() {
        return cinemaRepository.findAll();
    }

    // Lấy rạp chiếu phim (Cinemas) hiện đang chiếu phim (ByMovie) dựa vào lựa chọn thành phố (city)
    @Override
    public List<Cinema> getCinemaByMovieIdAndCity(int movieId, String city) {
        // Lấy CinemaIds dựa vào thành phố (city)
        List<Cinema> filteredCinemas = (city.equals("all"))
                ? cinemaRepository.findAll()
                : cinemaRepository.findByCity(city);

        // Trường hợp không có rạp
        if(filteredCinemas.isEmpty()) return Collections.emptyList();

        List<Integer> cinemaIds = filteredCinemas.stream()
                .map(Cinema::getId)
                .toList();

        // Lấy id tất cả các phòng(roomIds) của tất cả các Cinema
        List<Room> rooms = roomRepository.findByCinemaIdIn(cinemaIds);
        if(rooms.isEmpty()) return Collections.emptyList();
        List<Integer> roomIds = rooms.stream().map(Room::getId).toList();

        // Lấy tất cả các suất chiếu (showTimeIds) của phòng dựa vào (roomIds) ==> showtimeRoomIds
        List<ShowTime> showTimes = showTimeRepository.findByMovieIdAndRoomIdIn(movieId, roomIds);
        if(showTimes.isEmpty())return Collections.emptyList();
        List<Integer> showTimeRoomIds = showTimes.stream().map(showTime -> showTime.getRoom().getId()).toList();

        // Danh sách id của Cinema chiếu phim đó ở thành phố đó
        List<Integer> finalCinemaIds = rooms.stream()
                .filter(room -> showTimeRoomIds.contains(room.getId()))
                .map(room -> room.getCinema().getId())
                .distinct()
                .toList();

        return filteredCinemas.stream()
                .filter(cinema -> finalCinemaIds.contains(cinema.getId()))
                .toList();
    }

}

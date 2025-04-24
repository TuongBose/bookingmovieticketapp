package com.project.bookingmovieticketapp.Services.ShowTime;

import com.project.bookingmovieticketapp.Models.Cinema;
import com.project.bookingmovieticketapp.Models.Movie;
import com.project.bookingmovieticketapp.Models.Room;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Repositories.CinemaRepository;
import com.project.bookingmovieticketapp.Repositories.MovieRepository;
import com.project.bookingmovieticketapp.Repositories.RoomRepository;
import com.project.bookingmovieticketapp.Repositories.ShowTimeRepository;
import com.project.bookingmovieticketapp.Responses.ShowTimeResponse;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor
public class ShowTimeService implements IShowTimeService{
    private final ShowTimeRepository showTimeRepository;
    private final RoomRepository roomRepository;
    private final CinemaRepository cinemaRepository;
    private final MovieRepository movieRepository;

    @PostConstruct
    private void init(){
        generateShowtimesForAllRooms();
    }

    private void generateShowtimesForAllRooms(){
// Lấy tất cả phòng và phim
        List<Room> rooms = roomRepository.findAll();
        List<Movie> movies = movieRepository.findAll();
        Random random = new Random();

        if (movies.isEmpty() || rooms.isEmpty()) {
            System.out.println("No movies or rooms available to generate showtimes.");
            return;
        }

        // Tạo lịch chiếu cho 7 ngày tiếp theo, bắt đầu từ ngày mai
        LocalDate startDate = LocalDate.now().plusDays(1);  // Ngày mai
        LocalDate endDate = startDate.plusDays(7);          // 7 ngày sau

        // Các khung giờ cố định: 10:00, 13:00, 16:00, 19:00
        LocalTime[] timeSlots = {
                LocalTime.of(7,0),
                LocalTime.of(10, 0),  // 10:00
                LocalTime.of(13, 0),  // 13:00
                LocalTime.of(16, 0),  // 16:00
                LocalTime.of(19, 0)   // 19:00
        };

        // Duyệt qua từng ngày
        LocalDate currentDate = startDate;
        while (!currentDate.isAfter(endDate)) {
            // Duyệt qua từng phòng
            for (Room room : rooms) {
                // Duyệt qua từng khung giờ
                for (LocalTime timeSlot : timeSlots) {
                    LocalDateTime startTime = LocalDateTime.of(currentDate, timeSlot);

                    // Kiểm tra xem khung giờ này có bị trùng không
                    List<ShowTime> existingShowTimes = showTimeRepository.findByRoomIdAndShowdate(
                            room.getId(), currentDate
                    );

                    boolean isTimeSlotAvailable = true;
                    for (ShowTime showtime : existingShowTimes) {
                        LocalDateTime existingStartTime = showtime.getStarttime();
                        LocalDateTime existingEndTime = existingStartTime.plusMinutes(
                                movieRepository.findById(showtime.getMovie().getId())
                                        .map(Movie::getDuration)
                                        .orElse(120)  // Thời lượng mặc định: 120 phút
                        );

                        if ((startTime.isEqual(existingStartTime) || startTime.isAfter(existingStartTime)) &&
                                startTime.isBefore(existingEndTime)) {
                            isTimeSlotAvailable = false;
                            break;
                        }
                    }

                    if (!isTimeSlotAvailable) {
                        continue; // Bỏ qua nếu khung giờ bị trùng
                    }

                    // Chọn ngẫu nhiên một phim
                    Movie movie = movies.get((room.getId() + currentDate.getDayOfMonth()) % movies.size());
                    int price = 80000 + random.nextInt(71000);  // 80,000 + random(0-70,000) Giá tiền 1 suất xem phim là 80k - 150k

                    // Tạo lịch chiếu mới
                    ShowTime showtime = ShowTime.builder()
                            .movie(movie)
                            .room(room)
                            .showdate(currentDate)
                            .starttime(startTime)
                            .price(price)
                            .build();

                    showTimeRepository.save(showtime);
                    System.out.println("Created showtime for movie " + movie.getName() +
                            " in room " + room.getName() + " at " + startTime);
                }
            }
            currentDate = currentDate.plusDays(1);
        }
    }

    @Override
    public List<ShowTimeResponse> getShowTimeByMovieIdAndCinemaIdAndDate(int movieId, int cinemaId, LocalDate date) throws Exception{
        Cinema existingCinema = cinemaRepository.findById(cinemaId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay CinemaId"));

        Movie existingMovie = movieRepository.findById(movieId)
                .orElseThrow(()->new RuntimeException("Khong tim thay MovieId"));

        List<Room> rooms = roomRepository.findByCinema(existingCinema);
        List<Integer> roomIds = rooms.stream().map(Room::getId).toList();

        List<ShowTime> showTimeList = showTimeRepository.findByMovieAndRoomIdInAndShowdate(existingMovie, roomIds, date);

        List<ShowTimeResponse> showTimeResponseList = new ArrayList<>();
        for(ShowTime showTime : showTimeList)
        {
            ShowTimeResponse newShowTimeResponse = ShowTimeResponse
                    .builder()
                    .id(showTime.getId())
                    .movieId(showTime.getMovie().getId())
                    .roomId(showTime.getRoom().getId())
                    .showdate(showTime.getShowdate())
                    .starttime(showTime.getStarttime())
                    .price(showTime.getPrice())
                    .build();

            showTimeResponseList.add(newShowTimeResponse);
        }

        return showTimeResponseList;
    }


    public List<ShowTimeResponse> getShowtimesByCinemaIdAndDate(int cinemaId, LocalDate showDate) {
        List<ShowTime> showTimeList = showTimeRepository.findByCinemaIdAndShowdate(cinemaId, showDate);

        List<ShowTimeResponse> showTimeResponseList = new ArrayList<>();
        if(!showTimeList.isEmpty())
            for(ShowTime showTime:showTimeList)
            {
                ShowTimeResponse newShowTimeResponse = ShowTimeResponse
                        .builder()
                        .id(showTime.getId())
                        .movieId(showTime.getMovie().getId())
                        .roomId(showTime.getRoom().getId())
                        .showdate(showTime.getShowdate())
                        .starttime(showTime.getStarttime())
                        .price(showTime.getPrice())
                        .build();

                showTimeResponseList.add(newShowTimeResponse);
            }

        return showTimeResponseList;
    }
}

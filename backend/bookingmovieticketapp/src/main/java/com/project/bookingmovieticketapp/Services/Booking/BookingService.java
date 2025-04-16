package com.project.bookingmovieticketapp.Services.Booking;

import com.project.bookingmovieticketapp.DTOs.BookingDTO;
import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.ShowTime;
import com.project.bookingmovieticketapp.Models.User;
import com.project.bookingmovieticketapp.Repositories.BookingRepository;
import com.project.bookingmovieticketapp.Repositories.ShowTimeRepository;
import com.project.bookingmovieticketapp.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingService implements IBookingService {
    private final BookingRepository bookingRepository;
    private final ShowTimeRepository showTimeRepository;
    private final UserRepository userRepository;

    @Override
    public Booking createBooking(BookingDTO bookingDTO) throws Exception {
        User existingUser = userRepository.findById(bookingDTO.getUserid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay UserId"));

        ShowTime existingShowTime = showTimeRepository.findById(bookingDTO.getShowtimeid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay ShowTimeId"));

        Booking newBooking = Booking
                .builder()
                .user(existingUser)
                .showTime(existingShowTime)
                .bookingdate(LocalDateTime.now())
                .totalprice(bookingDTO.getTotalprice())
                .paymentmethod(bookingDTO.getPaymentmethod())
                .paymentstatus(bookingDTO.getPaymentstatus())
                .isactive(true)
                .build();
        bookingRepository.save(newBooking);
        return newBooking;
    }

    @Override
    public List<Booking> getBookingByShowTimeId(int id) throws Exception {
        ShowTime existingShowTime = showTimeRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay ShowTimeId"));

        return bookingRepository.findByShowTimeId(existingShowTime);
    }

    @Override
    public Booking getBookingById(int id) throws Exception {
        return bookingRepository.findById(id)
                .orElseThrow(()->new RuntimeException("Khong tim thay BookingId"));
    }

    @Override
    public List<Booking> getBookingByUserId(int id) throws Exception {
        User existingUser = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Khong tim thay UserId"));
        return bookingRepository.findByUserId(existingUser);
    }

    @Override
    public Booking updateBooking(int id, BookingDTO bookingDTO) throws Exception {
        Booking existingBooking = bookingRepository.findById(id)
                .orElseThrow(()->new RuntimeException("Khong tim thay BookingId"));

        User existingUser = userRepository.findById(bookingDTO.getUserid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay UserId"));

        ShowTime existingShowTime = showTimeRepository.findById(bookingDTO.getShowtimeid())
                .orElseThrow(() -> new RuntimeException("Khong tim thay ShowTimeId"));

        existingBooking.setUser(existingUser);
        existingBooking.setShowTime(existingShowTime);
        existingBooking.setTotalprice(bookingDTO.getTotalprice());
        existingBooking.setPaymentmethod(bookingDTO.getPaymentmethod());
        existingBooking.setPaymentstatus(bookingDTO.getPaymentstatus());

        bookingRepository.save(existingBooking);
        return existingBooking;
    }

    @Override
    public void deleteBooking(int id) throws Exception {
        Booking existingBooking = bookingRepository.findById(id)
                .orElseThrow(()->new RuntimeException("Khong tim thay BookingId"));
        existingBooking.setIsactive(false);
        bookingRepository.save(existingBooking);
    }
}

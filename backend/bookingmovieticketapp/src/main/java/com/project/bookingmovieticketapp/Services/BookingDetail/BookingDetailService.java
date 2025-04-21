package com.project.bookingmovieticketapp.Services.BookingDetail;

import com.project.bookingmovieticketapp.DTOs.BookingDetailDTO;
import com.project.bookingmovieticketapp.Models.Booking;
import com.project.bookingmovieticketapp.Models.BookingDetail;
import com.project.bookingmovieticketapp.Models.Seat;
import com.project.bookingmovieticketapp.Repositories.BookingDetailRepository;
import com.project.bookingmovieticketapp.Repositories.BookingRepository;
import com.project.bookingmovieticketapp.Repositories.SeatRepository;
import com.project.bookingmovieticketapp.Responses.BookingDetailResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class BookingDetailService implements IBookingDetailService{
    private final BookingDetailRepository bookingDetailRepository;
    private final BookingRepository bookingRepository;
    private final SeatRepository seatRepository;

    @Override
    public BookingDetail createBookingDetail(BookingDetailDTO bookingDetailDTO) throws Exception {
        Seat existingSeat = seatRepository.findById(bookingDetailDTO.getSeatid())
                .orElseThrow(()->new RuntimeException("Khong tim thay SeatId"));

        Booking existingBooking = bookingRepository.findById(bookingDetailDTO.getBookingid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay BookingId"));

        BookingDetail newBookingDetail = BookingDetail
                .builder()
                .booking(existingBooking)
                .seat(existingSeat)
                .price(bookingDetailDTO.getPrice())
                .build();
        bookingDetailRepository.save(newBookingDetail);
        return newBookingDetail;
    }

    @Override
    public BookingDetail getBookingDetailById(int id) throws Exception {
        return bookingDetailRepository.findById(id)
                .orElseThrow(()->new RuntimeException("Khong tim thay BookingDetailId"));
    }

    @Override
    public BookingDetail updateBookingDetail(int id, BookingDetailDTO bookingDetailDTO) {
        BookingDetail existingBookingDetail = bookingDetailRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Khong tim thay BookingDetailId"));

        Seat existingSeat = seatRepository.findById(bookingDetailDTO.getSeatid())
                .orElseThrow(()->new RuntimeException("Khong tim thay SeatId"));

        Booking existingBooking = bookingRepository.findById(bookingDetailDTO.getBookingid())
                .orElseThrow(()-> new RuntimeException("Khong tim thay BookingId"));

        existingBookingDetail.setBooking(existingBooking);
        existingBookingDetail.setSeat(existingSeat);
existingBookingDetail.setPrice(bookingDetailDTO.getPrice());
bookingDetailRepository.save(existingBookingDetail);
        return existingBookingDetail;
    }

    @Override
    public List<BookingDetailResponse> getBookingDetailByBookingId(int bookingId) throws Exception {
        Booking existingBooking = bookingRepository.findById(bookingId)
                .orElseThrow(()-> new RuntimeException("Khong tim thay BookingId"));
        List<BookingDetail> bookingDetailList = bookingDetailRepository.findByBookingId(existingBooking.getId());
        if(bookingDetailList.isEmpty())
            throw new RuntimeException("Khong co danh sach");

        List<BookingDetailResponse> bookingDetailResponseList = new ArrayList<>();
        for(BookingDetail bookingDetail: bookingDetailList)
        {
            BookingDetailResponse newBookingDetailResponse = BookingDetailResponse
                    .builder()
                    .id(bookingDetail.getId())
                    .bookingId(bookingDetail.getBooking().getId())
                    .seatId(bookingDetail.getSeat().getId())
                    .price(bookingDetail.getPrice())
                    .build();
            bookingDetailResponseList.add(newBookingDetailResponse);
        }
        return bookingDetailResponseList;
    }
}

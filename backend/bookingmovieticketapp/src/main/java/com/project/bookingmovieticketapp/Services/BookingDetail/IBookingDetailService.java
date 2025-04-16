package com.project.bookingmovieticketapp.Services.BookingDetail;

import com.project.bookingmovieticketapp.DTOs.BookingDetailDTO;
import com.project.bookingmovieticketapp.Models.BookingDetail;

import java.util.List;

public interface IBookingDetailService {
    BookingDetail createBookingDetail(BookingDetailDTO bookingDetailDTO) throws Exception;
    BookingDetail getBookingDetailById(int id) throws Exception;
    BookingDetail updateBookingDetail(int id, BookingDetailDTO bookingDetailDTO) throws Exception;
    List<BookingDetail> getBookingDetailByBookingId(int bookingId) throws Exception;
}

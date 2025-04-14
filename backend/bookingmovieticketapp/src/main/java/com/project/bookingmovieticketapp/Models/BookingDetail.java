package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "bookingdetails")
@Builder
public class BookingDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "bookingid")
    private Booking booking;

    @ManyToOne
    @JoinColumn(name = "seatid")
    private Seat seat;

    @Column(name = "price",nullable = false)
    private int price;
}

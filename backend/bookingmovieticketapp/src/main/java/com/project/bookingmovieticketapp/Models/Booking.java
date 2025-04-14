package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "bookings")
@Builder
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name ="userid")
    private User user;

    @ManyToOne
    @JoinColumn(name = "showtimeid")
    private ShowTime showTime;

    @Column(name = "bookingdate", nullable = false)
    private LocalDateTime bookingdate;

    @Column(name = "totalprice",nullable = false)
    private int totalprice;

    @Column(name = "paymentmethod",nullable = false)
    private int paymentmethod;

    @Column(name = "paymentstatus",nullable = false)
    private int paymentstatus;
}

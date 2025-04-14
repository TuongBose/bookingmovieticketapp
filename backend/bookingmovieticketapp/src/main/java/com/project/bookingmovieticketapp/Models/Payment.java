package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "payments")
@Builder
public class Payment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "bookingid")
    private Booking booking;

    @Column(name = "totalprice",nullable = false)
    private int totalprice;

    @Column(name = "paymentmethod",nullable = false)
    private int paymentmethod;

    @Column(name = "paymentstatus",nullable = false)
    private int paymentstatus;

    @Column(name = "paymenttime",nullable = false)
    private LocalDateTime paymenttime;
}

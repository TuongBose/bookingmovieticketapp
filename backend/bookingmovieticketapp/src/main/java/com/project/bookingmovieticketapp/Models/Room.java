package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "rooms")
@Builder
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "cinemaid")
    private Cinema cinema;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "seatcolumnmax",nullable = false)
    private int seatcolumnmax;

    @Column(name="seatrowmax",nullable = false)
    private int seatrowmax;
}

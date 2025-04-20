package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "showtimes")
@Builder
public class ShowTime {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "movieid")
    private Movie movie;

    @ManyToOne
    @JoinColumn(name = "roomid")
    private Room room;

    @Column(name = "showdate",nullable = false)
    private LocalDate showdate;

    @Column(name = "starttime",nullable = false)
    private LocalDateTime starttime;

    @Column(name = "price",nullable = false)
    private int price;
}

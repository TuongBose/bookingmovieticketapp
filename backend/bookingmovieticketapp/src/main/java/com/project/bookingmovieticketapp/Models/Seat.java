package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "seats")
@Builder
public class Seat {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @ManyToOne
    @JoinColumn(name = "roomid")
    private Room room;

    @Column(name = "seatnumber",nullable = false)
    private String seatnumber;
}

package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "cinemas")
@Builder
public class Cinema {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "city",nullable = false)
    private String city;

    private String coordinates;

    @Column(name = "address", nullable = false)
    private String address;

    private String phonenumber;
    private int maxroom;
}

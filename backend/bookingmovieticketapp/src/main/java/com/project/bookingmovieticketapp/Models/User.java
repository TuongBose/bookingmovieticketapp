package com.project.bookingmovieticketapp.Models;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;

@Entity
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "users")
@Builder
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "email", nullable = false)
    private String email;

    @Column(name = "password", nullable = false)
    private String password;

    @Column(name = "phonenumber", nullable = false)
    private String phonenumber;

    private String address;

    @Column(name = "dateofbirth", nullable = false)
    private Date dateofbirth;

    private LocalDateTime createdat;
    private boolean isactive;
    private boolean rolename;
    private String imagename;

    @PrePersist
    protected void onCreate() {
        createdat = LocalDateTime.now();
    }
}

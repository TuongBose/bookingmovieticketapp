package com.project.bookingmovieticketapp.DTOs;

import jakarta.validation.constraints.NotBlank;
import lombok.*;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserDTO {
    private String name;
    private String email;

    @NotBlank(message = "Password khong duoc bo trong")
    private String password;

    @NotBlank(message = "So dien thoai khong duoc bo trong")
    private String phonenumber;
    private String address;
    private Date dateofbirth;
}

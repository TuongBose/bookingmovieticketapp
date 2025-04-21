package com.project.bookingmovieticketapp.DTOs;

import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.*;

import java.util.Date;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
public class UserDTO {
    @NotBlank(message = "Họ và tên không được bỏ trống")
    private String name;

    @NotBlank(message = "Email không được bỏ trống")
    private String email;

    @NotBlank(message = "Password không được bỏ trống")
    private String password;

    @NotBlank(message = "Xác nhận mật khẩu không khớp")
    private String retypepassword;

    @NotBlank(message = "Số điện thoại không được bỏ trống")
    private String phonenumber;

    @NotNull(message = "Ngày sinh không được bỏ trống")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date dateofbirth;
}

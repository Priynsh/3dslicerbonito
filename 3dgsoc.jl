using Bonito, WGLMakie, LinearAlgebra

# Create the volume data
x = y = z = LinRange(-1.5, 1.5, 100)
vol = [begin
        r = √(X^2 + Y^2 + Z^2)
        if r > 1.2
            0  
        else
            (1.5 - r) * (1.5-abs(Z)) 
        end
    end for X ∈ x, Y ∈ y, Z ∈ z]

function volume_slicer(vol, x, y, z)
    App() do session::Session
        x_slice = Bonito.Slider(1:length(x), value=length(x)÷2)
        y_slice = Bonito.Slider(1:length(y), value=length(y)÷2)
        z_slice = Bonito.Slider(1:length(z), value=length(z)÷2)
        fig = Figure(size=(800, 600))
        ax = Axis3(fig[1, 1], aspect=:data, perspectiveness=0.5)
        
        min_point = Point3f(x[1], y[1], z[1])
        max_point = Point3f(x[end], y[end], z[end])
        wireframe!(ax, Rect3f(min_point, max_point - min_point), color=:black, linewidth=1)
        # z_val = z[80]
        # surface!(ax, x, y, fill(z_val, length(x), length(y)), color=vol[:, :, 80], colormap=:thermal)

        x_plane_pos = @lift x[$x_slice]
        y_plane_pos = @lift y[$y_slice]
        z_plane_pos = @lift z[$z_slice]
        x_data = @lift vol[$x_slice, :, :]
        y_data = @lift vol[:, $y_slice, :]
        z_data = @lift vol[:, :, $z_slice]

        
        surface_plotx = surface!(ax,fill(x[50],length(z),length(y)),repeat(y, 1, length(z)), repeat(z', length(y), 1),   color=x_data, colormap=:thermal)
        on(x_slice) do slice_idx
            x_data[] = vol[Int(slice_idx), :, :] 
            surface_plotx[1] = fill(x[Int(slice_idx)], length(y), length(z))
        end
        surface_ploty = surface!(ax,repeat(x, 1, length(z)),fill(y[50], length(x), length(z)), repeat(z', length(y), 1),   color=y_data, colormap=:thermal)
        on(y_slice) do slice_idx
            y_data[] = vol[Int(slice_idx), :, :] 
            surface_ploty[2] = fill(y[Int(slice_idx)], length(x), length(z))
        end
        surface_plotz = surface!(ax, x, y, fill(z[50], length(x), length(y)), color=z_data, colormap=:thermal)
        on(z_slice) do slice_idx
            z_data[] = vol[:, :, Int(slice_idx)]
            surface_plotz[3] = fill(z[Int(slice_idx)], length(x), length(y))
        end
        ax_xy = Axis3(fig[1, 2], title="(X, Y, Temp)")
        ax_yz = Axis3(fig[2, 1], title="(Y, Z, Temp)")
        ax_xz = Axis3(fig[2, 2], title="(X, Z, Temp)")
        scatter_xy = scatter!(ax_xy, x, y, vol[:, :, length(z)÷2], colormap=:thermal)
        scatter_yz = scatter!(ax_yz, y, z, vol[length(x)÷2, :, :], colormap=:thermal)
        scatter_xz = scatter!(ax_xz, x, z, vol[:, length(y)÷2, :], colormap=:thermal)
        sliders = DOM.div(
            DOM.h3("Slice Positions"),
            DOM.div("X Plane: ", x_slice),
            DOM.div("Y Plane: ", y_slice),
            DOM.div("Z Plane: ", z_slice)
        )
        DOM.div(
            fig,sliders
        )
    end
end

function start_server()
    app = volume_slicer(vol, x, y, z)
    Bonito.Server(app, "0.0.0.0", 8000)
end

start_server()
import { gql, useApolloClient, useMutation } from "@apollo/client"
import { useState } from 'react'
import Video from "./Video"

const CREATE_VIDEO = gql`
    mutation createVideo($images: [String]) {
        createVideo(images: $images) {
            videoPath
        }
    }
`

export default function UploadForm() {
    const [videoUrl, setVideoUrl] = useState('')
    const [createVideo] = useMutation(CREATE_VIDEO, {
        onCompleted: data => {
            console.log(data.createVideo.videoPath)
            console.log(data)
            setVideoUrl('http://localhost:4000/' + data.createVideo.videoPath)
        }
    })
    const apolloClient = useApolloClient()

    const toBase64 = file => new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
    });

    const handleFileChange = async ({ target: { validity, files } }) => {
        if (validity.valid && files && files[0]) {
            const encodedVideos = []
            for (const f of Object.values(files)) {
                const encoded = await toBase64(f)
                encodedVideos.push(encoded)
            }

            console.log(encodedVideos)

            createVideo({ variables: { images: encodedVideos } }).then(() => {
                apolloClient.resetStore()
            });
        }
    }

    return (
        <div>
            <div>
                <h1>Upload images</h1>
                <input type="file" multiple onChange={handleFileChange} />
            </div>

            <div>
                {videoUrl &&
                    <Video videoUrl={videoUrl}></Video>
                }
            </div>
        </div>
    )
}